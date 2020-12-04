#!/bin/sh

numb='524'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 40 --keyint 300 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.6,1.4,3.0,0.6,0.9,0.7,3,0,16,40,300,2,29,40,4,0,69,48,3,2000,-1:-1,hex,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"