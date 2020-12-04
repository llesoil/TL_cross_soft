#!/bin/sh

numb='1964'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 30 --keyint 220 --lookahead-threads 1 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.3,1.2,4.2,0.5,0.8,0.7,0,1,8,30,220,1,28,30,5,4,61,18,3,1000,-2:-2,umh,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"