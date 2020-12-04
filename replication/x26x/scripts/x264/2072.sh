#!/bin/sh

numb='2073'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.0,1.0,0.4,0.4,0.9,0.7,0,2,8,10,300,2,24,30,4,2,65,38,5,2000,-2:-2,umh,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"