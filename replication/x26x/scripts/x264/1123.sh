#!/bin/sh

numb='1124'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.1,1.4,4.6,0.2,0.7,0.4,1,2,16,20,210,1,27,10,3,2,67,28,5,1000,1:1,hex,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"