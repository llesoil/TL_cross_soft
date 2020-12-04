#!/bin/sh

numb='20'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 0 --keyint 290 --lookahead-threads 0 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.3,1.3,0.4,0.6,0.6,0.4,3,1,16,0,290,0,22,40,4,1,68,28,1,2000,1:1,umh,show,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"