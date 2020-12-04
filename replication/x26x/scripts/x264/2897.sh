#!/bin/sh

numb='2898'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.4,1.1,0.8,0.2,0.6,0.2,3,0,12,45,220,1,27,10,3,2,62,38,4,1000,-2:-2,dia,crop,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"