#!/bin/sh

numb='398'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 20 --keyint 230 --lookahead-threads 4 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.5,1.3,3.2,0.6,0.8,0.5,3,0,10,20,230,4,23,40,4,4,65,48,3,1000,1:1,hex,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"