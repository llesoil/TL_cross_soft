#!/bin/sh

numb='2297'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 20 --keyint 260 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.5,1.2,3.4,0.4,0.6,0.2,3,2,16,20,260,1,24,40,3,1,68,38,2,2000,1:1,umh,crop,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"