#!/bin/sh

numb='1259'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 25 --keyint 250 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.4,1.1,1.8,0.4,0.8,0.9,3,1,10,25,250,0,20,40,3,4,69,38,6,2000,-2:-2,umh,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"