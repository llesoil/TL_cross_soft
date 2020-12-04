#!/bin/sh

numb='2447'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 10 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.3,0.4,0.6,0.6,0.0,2,1,16,10,220,4,22,0,3,1,68,48,1,2000,1:1,umh,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"