#!/bin/sh

numb='2819'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.4,1.2,2.6,0.5,0.6,0.8,2,1,6,45,240,2,25,20,3,4,61,38,2,2000,-2:-2,dia,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"