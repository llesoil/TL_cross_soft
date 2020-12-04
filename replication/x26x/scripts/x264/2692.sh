#!/bin/sh

numb='2693'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 5 --keyint 210 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.0,1.0,3.8,0.6,0.6,0.0,0,1,4,5,210,0,29,40,4,1,62,28,4,2000,1:1,dia,show,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"