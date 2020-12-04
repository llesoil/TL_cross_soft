#!/bin/sh

numb='2005'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 50 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.2,1.2,2.8,0.4,0.7,0.4,2,2,0,50,220,2,26,30,3,2,60,38,2,2000,-2:-2,dia,crop,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"