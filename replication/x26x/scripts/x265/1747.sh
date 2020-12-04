#!/bin/sh

numb='1748'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 35 --keyint 220 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.0,0.2,0.3,0.6,0.9,3,2,16,35,220,3,30,40,3,2,60,48,4,1000,1:1,hex,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"