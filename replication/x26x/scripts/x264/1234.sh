#!/bin/sh

numb='1235'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.1,1.4,3.0,0.3,0.7,0.2,3,1,4,40,260,0,27,20,3,1,60,28,6,2000,-2:-2,dia,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"