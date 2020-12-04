#!/bin/sh

numb='1324'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 10 --keyint 240 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.2,1.1,0.2,0.5,0.6,0.7,1,1,2,10,240,3,24,0,4,2,65,28,4,1000,1:1,umh,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"