#!/bin/sh

numb='1592'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 40 --keyint 220 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.5,1.3,4.2,0.5,0.8,0.3,2,1,8,40,220,1,23,20,5,2,61,28,1,2000,-1:-1,umh,crop,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"