#!/bin/sh

numb='861'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 15 --keyint 260 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.0,1.1,3.2,0.4,0.7,0.3,3,0,10,15,260,3,21,40,5,3,67,48,2,2000,1:1,umh,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"