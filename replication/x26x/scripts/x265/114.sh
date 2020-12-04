#!/bin/sh

numb='115'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.0,4.8,0.6,0.9,0.5,2,2,0,35,250,4,22,50,4,1,65,38,4,2000,-2:-2,dia,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"