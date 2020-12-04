#!/bin/sh

numb='2846'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 20 --keyint 250 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.2,1.1,2.0,0.2,0.7,0.8,3,2,12,20,250,3,23,40,4,2,61,38,6,1000,1:1,hex,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"