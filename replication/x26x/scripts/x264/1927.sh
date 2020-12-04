#!/bin/sh

numb='1928'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.3,1.0,3.0,0.5,0.6,0.8,1,1,2,40,300,1,20,20,3,2,60,18,5,2000,-2:-2,dia,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"