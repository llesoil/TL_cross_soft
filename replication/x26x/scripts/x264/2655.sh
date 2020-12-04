#!/bin/sh

numb='2656'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 35 --keyint 300 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.5,1.0,0.6,0.4,0.6,0.1,2,0,16,35,300,2,23,0,5,1,61,18,3,1000,1:1,umh,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"