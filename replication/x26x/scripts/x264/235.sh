#!/bin/sh

numb='236'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 40 --keyint 290 --lookahead-threads 0 --min-keyint 21 --qp 20 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.2,1.3,4.2,0.3,0.7,0.5,0,2,12,40,290,0,21,20,4,4,63,38,6,1000,1:1,hex,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"