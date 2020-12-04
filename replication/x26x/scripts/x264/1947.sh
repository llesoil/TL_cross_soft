#!/bin/sh

numb='1948'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 25 --keyint 210 --lookahead-threads 4 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.3,1.1,4.0,0.4,0.6,0.8,0,0,4,25,210,4,28,20,4,3,65,28,5,2000,-1:-1,dia,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"