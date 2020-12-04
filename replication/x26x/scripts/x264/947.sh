#!/bin/sh

numb='948'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 1 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.0,1.1,4.8,0.2,0.9,0.4,0,1,6,50,240,1,20,40,3,2,61,48,5,1000,-1:-1,umh,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"