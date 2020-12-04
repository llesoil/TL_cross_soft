#!/bin/sh

numb='473'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 30 --keyint 290 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.0,0.8,0.5,0.8,0.0,3,1,16,30,290,1,24,30,4,2,64,18,2,1000,-1:-1,umh,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"